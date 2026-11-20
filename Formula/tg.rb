class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.10.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.10.2/tg-v2.10.2-darwin-arm64.tar.gz"
      sha256 "405e02580309eef228a79b5aa7ad2f4862fced05cc89a414c9ac6f5d3ac6d364"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.10.2/tg-v2.10.2-linux-arm64.tar.gz"
      sha256 "f4dae41303a0f7aadc54ba6ec3243bd0514789df969fc1c9079a743878ee52f2"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.10.2/tg-v2.10.2-linux-x86_64.tar.gz"
      sha256 "2e7b4e84a44e4a344e0ddd4b43b88bfadae62ba6635d0ad03778217321ee1a12"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "ffmpeg"
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
