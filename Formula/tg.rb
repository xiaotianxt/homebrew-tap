class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.3.0/tg-v2.3.0-darwin-arm64.tar.gz"
      sha256 "ca35acf7a981a68e582545333a416c5190563139d079922377bb4c845533230c"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.3.0/tg-v2.3.0-linux-arm64.tar.gz"
      sha256 "e767146d35ceac620c378fe1458e6188f1cbfa232ad33a105ad3ae3b1be4290e"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.3.0/tg-v2.3.0-linux-x86_64.tar.gz"
      sha256 "108660fd36489f92b0ee7808ff96c37df3651ca8424cb7d27b27ce84234d86f8"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def caveats
    <<~EOS
      `tg keys --method login` uses LLDB on macOS or GDB on Linux while you log out and back in once.
      Install Apple Command Line Tools on macOS, or GDB on Linux, when that mode is needed.
    EOS
  end

  def install
    bin.install "tg"
    doc.install "LICENSE", "THIRD_PARTY_LICENSES"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
