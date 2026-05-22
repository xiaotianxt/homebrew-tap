class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.22"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.22/tg-v1.4.22-darwin-arm64.tar.gz"
      sha256 "c6cfbf07c909951b60d1fa13dd80285df481d360102e4380c586e7902ee0aaaa"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.22/tg-v1.4.22-linux-arm64.tar.gz"
      sha256 "d865a20e7ae3afd1af1e51f4b84c69cf6b0c5642b79e07e149ebe6d77867e052"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.22/tg-v1.4.22-linux-x86_64.tar.gz"
      sha256 "7a611dae6b1743496f04c697091b4222737cee17ff275eebae27cc8b6c3dd556"
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
