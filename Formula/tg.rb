class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.0.0/tg-v2.0.0-darwin-arm64.tar.gz"
      sha256 "cfb0c4474ac4c15ca28c895f2da62e6d1505633893545c6290ac35f95cc92318"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.0.0/tg-v2.0.0-linux-arm64.tar.gz"
      sha256 "3449595ada456098764245286b30f782bc850ffc641843875d78b00b1f1a2aed"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.0.0/tg-v2.0.0-linux-x86_64.tar.gz"
      sha256 "ccb8589282e7d3e59e5a498b06c89dfd40ba0b770369c671554ae61ae7963594"
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
