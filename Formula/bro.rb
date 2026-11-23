class Bro < Formula
  desc "Local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "2.2.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.2.0/bro-v2.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "0e84ae5d1b47b9158fd1029374415b79b50036833c318d9bb48aa11fc5fe0ef1"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.2.0/bro-v2.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "2e8d11a114e40391e7c5854cad868acd439f1ea76d4ddadd8d6987c189787ef6"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.2.0/bro-v2.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "794861a5072d394747e400c89814345665d13b44f457f20c313ecebf5b1ced71"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.2.0/bro-v2.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4fdf59909e1e01a6e047087c30e22d39bc49b8ea3b7cec299703fa87119a1c92"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "go" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v2.2.0/bro-extension-v2.2.0.zip"
    sha256 "59a0b619c9a4969804ab17297b1d45ba0ffbb9184cd0f7f842b5770ffbbdbb92"
  end

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"bro"), "./cmd/bro"
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
