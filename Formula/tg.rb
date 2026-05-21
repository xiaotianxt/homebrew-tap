class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.21"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.21/tg-v1.4.21-darwin-arm64.tar.gz"
      sha256 "7e2c874701e3e2b4354ce49fd2699baf3db2e3dec13895be73c15520f3c7449d"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.21/tg-v1.4.21-linux-arm64.tar.gz"
      sha256 "0c7068174a036b88dca1792b96acf2ad733b05899194d005892344d9be12b897"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.21/tg-v1.4.21-linux-x86_64.tar.gz"
      sha256 "c12c15ee7ae80d205a490dac3c608cc3f177bffb6c13cf7905667e6951e14e0b"
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
