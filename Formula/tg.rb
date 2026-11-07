class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.7.0/tg-v2.7.0-darwin-arm64.tar.gz"
      sha256 "9a86f3e739d87c46512dc7b4b2f59b4021eb220a97c969b5a1078f2455ce3533"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.7.0/tg-v2.7.0-linux-arm64.tar.gz"
      sha256 "6120e8ca97e31ccee500d116fe695c583d226bfbf7f51f620ed640118581d78e"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.7.0/tg-v2.7.0-linux-x86_64.tar.gz"
      sha256 "ab7f0f918f00490384af570f36b80520377cc3857a550a19d66012c9645bdc25"
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
