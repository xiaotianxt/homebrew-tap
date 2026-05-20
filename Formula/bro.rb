class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "0.2.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.1/bro-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "ec3d90b14ecaa499751de743505696bd8e6c7b95c1b752829b18907f084a84f5"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.1/bro-v0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "20a3fe3880df82e5ccade2cbf61a6d5815e2059dae3d4ca1b93093bb0b4ae544"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.1/bro-v0.2.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9bef890555345ef4967f21b09ffa06e9db0971db536e0938738f0d68c3380d80"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.1/bro-v0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8d2ac26e8356a474068ca32c003308cb0c399e57873a739f05fbaa740e8e6519"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v0.2.1/bro-extension-v0.2.1.zip"
    sha256 "c113d51cc6752a81ad2c22351114c5fd402e472c7c64ebd6448901871b213b20"
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
