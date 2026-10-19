class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.3.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.3.1/tg-v2.3.1-darwin-arm64.tar.gz"
      sha256 "e5a96eb3676770d7f989708ca4a9b1a5509d6497ab56c56481f338ca9a1e1389"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.3.1/tg-v2.3.1-linux-arm64.tar.gz"
      sha256 "a83e0c123d780486500e6cac2c7f23fafe47d930175fe303ae39b0160d25a471"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.3.1/tg-v2.3.1-linux-x86_64.tar.gz"
      sha256 "5ecd3f27e3656c8f031c9dc369be638aa8655c215a98a49527d9e69fa1da631d"
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
