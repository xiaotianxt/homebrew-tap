class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.19"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.19/tg-v1.4.19-darwin-arm64.tar.gz"
      sha256 "bc150eb03e7279c900d94f57ba73e94dd6d1f2c127884c0533d50512e6c012b1"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.19/tg-v1.4.19-linux-arm64.tar.gz"
      sha256 "681aa8654ac0127ed7e1aec546e8a28938afa6df994fbe05e6a155070b5f58c3"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.19/tg-v1.4.19-linux-x86_64.tar.gz"
      sha256 "f3fb7bb29562347ecba67ceb9f1f2d710c0ba3d4908357c2f78949ee98c73678"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def install
    bin.install "tg"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
