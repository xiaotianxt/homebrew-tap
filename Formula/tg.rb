class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.4.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.1/tg-v2.4.1-darwin-arm64.tar.gz"
      sha256 "41e3998a3f57c090ae59a0a83e233c4056d083aa1d0bd071193476aba59c34e0"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.1/tg-v2.4.1-linux-arm64.tar.gz"
      sha256 "e2458ed5f990850203ec125c9e62096b66b650ddb79090d1e2d3303f9c7eb13a"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.1/tg-v2.4.1-linux-x86_64.tar.gz"
      sha256 "b9f70511493c7d3dc96bdd99f0c0935bd6ad5b79ec2b400d7c6534baa9f7244d"
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
