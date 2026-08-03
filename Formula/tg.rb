class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.2.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.2.1/tg-v2.2.1-darwin-arm64.tar.gz"
      sha256 "d1ac861383ab1f6c7fd1fad349dc7d5ac3efb62c718190d90ec86f1fbdc4bbc8"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.2.1/tg-v2.2.1-linux-arm64.tar.gz"
      sha256 "6363f3349c8886a03c4e5b40222fae2cda801645f2a1f3890046452aa621c6dc"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.2.1/tg-v2.2.1-linux-x86_64.tar.gz"
      sha256 "5b7baf982537349665642e0510419294c850e62be3ba5c3f89e42266a61a3b9c"
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
