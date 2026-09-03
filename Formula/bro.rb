class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.0.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.1/bro-v1.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "e414f2321c769632d6347a669d19aeba56db49c757c0bf798e5271402f9d90de"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.1/bro-v1.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "9168d516dfc8ef39caee230fdc224e3261bd38874cf3fa6ca7412dd0a6ed0c54"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.1/bro-v1.0.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "25a997c6a0bb4d27778ea2d9bbb78ba56fd784bdacf8b305a95775b1894aa4bf"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.0.1/bro-v1.0.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3f406b4b6e7f102afe0c18d0b69ca801d2f600d0af0a520f8a3c355be6d8ab61"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.0.1/bro-extension-v1.0.1.zip"
    sha256 "a8776cd95b8aa8351510262c6ce05ef99b45dc492c7520a0616a8f83ed2cd3e3"
  end

  def install
    if build.head?
      system "cargo", "install", "--locked", "--bin", "bro", "--root", prefix, "."
    else
      bin.install "bro"
    end

    resource("extension").stage do
      (share/"bro/extension").install Dir["*"]
    end
  end

  service do
    run [opt_bin/"bro", "serve"]
    keep_alive true
    log_path var/"log/bro.log"
    error_log_path var/"log/bro.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bro --version")
    assert_predicate share/"bro/extension/manifest.json", :exist?
  end
end
