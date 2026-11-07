class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.6.0/tg-v2.6.0-darwin-arm64.tar.gz"
      sha256 "9d4fd900000d09bd87978f98f22be75e3bb29268d587ae85b8b71b595a247af4"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.6.0/tg-v2.6.0-linux-arm64.tar.gz"
      sha256 "f9007e90178ccab422334f2e450846254591ab1345eaf4bd8dd26a047c998f0d"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.6.0/tg-v2.6.0-linux-x86_64.tar.gz"
      sha256 "34ab1620e394b5454a498d3a48fd20ec9ad97a1ad212f82cb4ceebfe7d31e0a4"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def caveats
    <<~EOS
      `tg keys --method login` uses LLDB on macOS or GDB on Linux while you log out and back in once.
      Install Apple Command Line Tools on macOS, or GDB on Linux, when that mode is needed.
    EOS
  end

  def install
    bin.install "tg"
    doc.install "LICENSE", "THIRD_PARTY_LICENSES"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
