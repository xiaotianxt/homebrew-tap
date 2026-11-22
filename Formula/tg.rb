class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "3.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v3.1.0/tg-v3.1.0-darwin-arm64.tar.gz"
      sha256 "2d3c7e4a91330c9eb16dce21a7f9388b34f53e71102d35d2695c632b6e349db7"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v3.1.0/tg-v3.1.0-linux-arm64.tar.gz"
      sha256 "f764f6d0637b9de377e764a40bfbdcc5005ba17d3968c1404c955b80b295539a"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v3.1.0/tg-v3.1.0-linux-x86_64.tar.gz"
      sha256 "28eafb86c833a56e0b84b10e27871d7e02a9c2f6cd059402764036fb504e81af"
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
