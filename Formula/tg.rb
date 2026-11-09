class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.8.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.8.0/tg-v2.8.0-darwin-arm64.tar.gz"
      sha256 "b9185a3fdc3896cc51564471b8e03923be74e7e342e20ba7506ad004005c390f"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.8.0/tg-v2.8.0-linux-arm64.tar.gz"
      sha256 "5e31d38dcca353d8d2fea7e933e0f4ef537a1d8c03f0751974d012c52d289827"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.8.0/tg-v2.8.0-linux-x86_64.tar.gz"
      sha256 "ab3c872d0b72eea7587ce8734b4c232ea52498b36b1276dc8f3653947a58257b"
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
