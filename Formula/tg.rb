class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.20"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.20/tg-v1.4.20-darwin-arm64.tar.gz"
      sha256 "445828a1fb7bc325785fa8e342bd5030e1760085744903d8f056acdd87415b8e"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.20/tg-v1.4.20-linux-arm64.tar.gz"
      sha256 "5af6761b83e30571b2bc680060adeab4134857236f73074d6d42737887d788b7"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.20/tg-v1.4.20-linux-x86_64.tar.gz"
      sha256 "43607ffda941c3993cad73913150687ae8fb2d98bdfe872400d11765f6bc8a8f"
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
