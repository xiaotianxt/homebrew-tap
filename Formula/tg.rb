class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.16"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.16/tg-v1.4.16-darwin-arm64.tar.gz"
      sha256 "36132b5a381707bcda21ec7d194123801eadbd6de84fa1d6114e1a538ff9a86f"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.16/tg-v1.4.16-linux-arm64.tar.gz"
      sha256 "f11e0bff06c541cd586b2c48a6ce9cee73e687d1431dd92edfebc43e0623cd96"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.16/tg-v1.4.16-linux-x86_64.tar.gz"
      sha256 "8fa654d8b4f1a497c48d85f35c1b77a50a51784cfd03921c435fc18cffdfaae0"
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
