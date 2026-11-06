class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.0/tg-v2.4.0-darwin-arm64.tar.gz"
      sha256 "28f0922a806d2f402656e5f456b0e7a27afca72d3e719c69711fa73d50b030e9"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.0/tg-v2.4.0-linux-arm64.tar.gz"
      sha256 "dc011cef48dd6b6177e7359d2a57445c1265bb9cd913c621600c6267cdcc5564"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.0/tg-v2.4.0-linux-x86_64.tar.gz"
      sha256 "6c65850df82156687c6c388743852f6ed0a2b967aa6cfce5c0d5e15ffdefbc24"
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
