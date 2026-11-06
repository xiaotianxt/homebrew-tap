class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.4.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.2/tg-v2.4.2-darwin-arm64.tar.gz"
      sha256 "7499d8923d12e728d7ec3f184b27c30c29bad10f4df14b809601f4d8cccffaa9"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.2/tg-v2.4.2-linux-arm64.tar.gz"
      sha256 "36795522c534f87362064a4f9411b31d1251ce88e87c0a9ab53e008d63cdd56e"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.2/tg-v2.4.2-linux-x86_64.tar.gz"
      sha256 "1ffef32f7b624518ddeed5e3ab57429573ddb865460ecbc79030f6331b3d3d64"
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
