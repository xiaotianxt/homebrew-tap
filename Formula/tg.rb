class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.4.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.3/tg-v2.4.3-darwin-arm64.tar.gz"
      sha256 "6d4c270331a3af0c18d72a5e8d878166c2aa636ea37803a1f25764d86597239f"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.3/tg-v2.4.3-linux-arm64.tar.gz"
      sha256 "72538a21c6e7dfa564a4c6b64cd6ceff72bd7fb00f2c11463e5dfd27d1a3ff46"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.3/tg-v2.4.3-linux-x86_64.tar.gz"
      sha256 "1ab08bdb1be45ed016ea24001bf12b51fbc37db01a95cb30334d4a57c10f399f"
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
