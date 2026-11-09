class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.8.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.8.1/tg-v2.8.1-darwin-arm64.tar.gz"
      sha256 "655cc381fac2a2827cb7b97f03d91212ceabce5a9b797b15c19dd9dc143721a8"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.8.1/tg-v2.8.1-linux-arm64.tar.gz"
      sha256 "f13dd4d18e342605f0c530003a9003b9e3664d5dc93e49b6b412f4dcd6837419"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.8.1/tg-v2.8.1-linux-x86_64.tar.gz"
      sha256 "cb3f55462054c364a5519b438d2ed2c6d9684cbcc7515e53527f6e15926ca244"
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
