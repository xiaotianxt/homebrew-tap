class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.9.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.9.2/tg-v2.9.2-darwin-arm64.tar.gz"
      sha256 "fa7449803056d69bc57285a0b10eb8200c7986bc9cb4f5ab3f0969604510dd61"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.9.2/tg-v2.9.2-linux-arm64.tar.gz"
      sha256 "4f4d284739d3e7324763da98dc0f07315b2e85c5f0f0152abd21a1e0ddfe6a41"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.9.2/tg-v2.9.2-linux-x86_64.tar.gz"
      sha256 "be11be3f04ab4bfbd73b0545bfb84397b79ed3adae57d261d514e48faccf3773"
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
