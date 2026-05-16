class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.14"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.14/tg-v1.4.14-darwin-arm64.tar.gz"
      sha256 "a4d6267a1b5eef114e8103fbdb6366dd15a39a2fb44ec36dfbd69d896bc492d2"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.14/tg-v1.4.14-linux-arm64.tar.gz"
      sha256 "a8d687102259c29f660c0f8b9d6b2128ba6944458a6e9fddfe6b52f34e3712dc"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.14/tg-v1.4.14-linux-x86_64.tar.gz"
      sha256 "66087a1e53cbb473f08e5f87f1bb543f12cb81b6904cf832ecaac5e03a71e8f2"
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
