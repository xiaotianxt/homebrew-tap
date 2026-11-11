class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.9.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.9.1/tg-v2.9.1-darwin-arm64.tar.gz"
      sha256 "6fc7958164b61d1802d737359d7ee6fe63eb8c6279f011483e78f4a4ef66d677"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.9.1/tg-v2.9.1-linux-arm64.tar.gz"
      sha256 "85a30da7ef0d5aafff5572516348dc45ba76e90f7029d3cf0d8e5092ed6d492f"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.9.1/tg-v2.9.1-linux-x86_64.tar.gz"
      sha256 "122172c95652e148fa1a1d2ab2f423035e4a5c4d33858c2b447083268ed1622b"
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
