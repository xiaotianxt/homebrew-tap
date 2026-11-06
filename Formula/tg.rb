class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.5.0/tg-v2.5.0-darwin-arm64.tar.gz"
      sha256 "054ea4cc9526e68102f4b31947d77bd4406b6fc3328588742227dde9f7727c82"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.5.0/tg-v2.5.0-linux-arm64.tar.gz"
      sha256 "7d1b9aa23ab5d739cea1109f707d2b1cd7c7f42dc664fee974d60dd059cd0279"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.5.0/tg-v2.5.0-linux-x86_64.tar.gz"
      sha256 "dda10db4d524a46b5e040f61cde9c80e773be9be4a94427228db61ca428389d8"
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
