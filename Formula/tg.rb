class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.26"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.26/tg-v1.4.26-darwin-arm64.tar.gz"
      sha256 "1a74e777391255f566398addfa8b8f66c500e545c12b0daabe454afb23e6f7a8"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.26/tg-v1.4.26-linux-arm64.tar.gz"
      sha256 "182fadd91e5ec519495f17a86606f1711895fd4d3613ca1d87eab94d1d7bd0b4"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.26/tg-v1.4.26-linux-x86_64.tar.gz"
      sha256 "6d30a5338a6d3f352363b30320f46f37e8096c32acb17270016bd7af0d59ea38"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def caveats
    <<~EOS
      `tg keys --method lldb-login` uses Apple's lldb/debugserver while you log out and back in once.
      Install Apple Command Line Tools when that mode is needed:
        xcode-select --install
    EOS
  end

  def install
    bin.install "tg"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
