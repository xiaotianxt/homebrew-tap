class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.24"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.24/tg-v1.4.24-darwin-arm64.tar.gz"
      sha256 "1990d042886897d0bcad4bc45717cf6776ebab0d8ff92c497a326e2f812d7fae"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.24/tg-v1.4.24-linux-arm64.tar.gz"
      sha256 "595ab6452f5f914667bcd7b5f005c958a357cf9ed197c18389155c9aab95c358"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.24/tg-v1.4.24-linux-x86_64.tar.gz"
      sha256 "dd5778b29a803cac41bbbbb1977cf169e8a1df1b30c379ca0fadd1262c15bb23"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def caveats
    <<~EOS
      `tg keys --method lldb-cold` uses Apple's lldb/debugserver.
      Install Apple Command Line Tools when that mode is needed:
        xcode-select --install
    EOS
  end

  def install
    bin.install "tg"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
