class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.10.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.10.1/tg-v2.10.1-darwin-arm64.tar.gz"
      sha256 "b838ceaf715ed8a2fd559d070e9387aba20d9a88f28b288368efbec06368fd9d"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.10.1/tg-v2.10.1-linux-arm64.tar.gz"
      sha256 "bef5c91304c2d02db91afd477b7d4fac4c79726df9d3bd82273920b342ec0eeb"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.10.1/tg-v2.10.1-linux-x86_64.tar.gz"
      sha256 "1578b252f24aa7857806eb881379f0ac711be43f211c567618b7a67ca0a3322c"
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
