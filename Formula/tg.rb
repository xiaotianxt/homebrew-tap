class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.1.1/tg-v2.1.1-darwin-arm64.tar.gz"
      sha256 "bee8e36ec50a42c14d217c2d5a9eba367ef517f24f903cbda736d00394450fe6"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.1.1/tg-v2.1.1-linux-arm64.tar.gz"
      sha256 "b40e25254829a9f067765bc6ec46e91339134bf34cad8634a4e6c90de39c116e"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.1.1/tg-v2.1.1-linux-x86_64.tar.gz"
      sha256 "f405909d7e166276c9d8ff042607b8534237c8ab129da4654938b2e0b95af2d9"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def caveats
    <<~EOS
      `tg keys --method lldb-login` uses Apple's lldb/debugserver while you log out and back in once.
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
