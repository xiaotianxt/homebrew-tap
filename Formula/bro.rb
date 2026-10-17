class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.3.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.0/bro-v1.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "7936296f4a1be071226cfa511a894386263040eba59cd677056ade351d0214b3"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.0/bro-v1.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "915440ee700f999b9e4a19643020addc1e673a7be90db190441e0ca0db9a5d17"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.0/bro-v1.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bced7c15ed4afe4fb4ddaffebe573fd913b2fddf49495f6a4c5d790fe7adb03e"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.3.0/bro-v1.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "82ab3c5d9dd62a0bfa04d2e2ee7ab76954af2685e329dedb08704899a2b964f8"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.3.0/bro-extension-v1.3.0.zip"
    sha256 "f97f8b2cc47b628f07f7f1166be37cdd5952f467d0af91ce4f0737fcce20e2f6"
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
