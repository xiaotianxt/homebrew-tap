class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.18"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.18/tg-v1.4.18-darwin-arm64.tar.gz"
      sha256 "eb2099963e8b1f268947650d691487117392b983628c8ffc0e9c30b636ed718b"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.18/tg-v1.4.18-linux-arm64.tar.gz"
      sha256 "f168b0a14d17b24926cd2a51981452b9fadc4cfd6d758978a3ecec2b8366afd6"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.18/tg-v1.4.18-linux-x86_64.tar.gz"
      sha256 "1e8b8469e0248ed0e13becc1355823fb8ff8384416e6aeee0074932661b205c4"
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
