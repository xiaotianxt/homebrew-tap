class Bro < Formula
  desc "Local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "2.0.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.0.0/bro-v2.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "17cf81217b068e1c24f7fda50d41b50096ff79f3bee59c19534f55227d28db07"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.0.0/bro-v2.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "a269aa92c599c968d27b4e71015319aa616322560c165d87c26fde68a437831b"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.0.0/bro-v2.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5e84b7b19b7ab29448b4e45767e9f6bdc229fc0e765acc449100b3aefab5dff1"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.0.0/bro-v2.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3adca9e46ca897403cb15736d7f1b83173ee778e7c91667a0cdc75f3f8370f16"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "go" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v2.0.0/bro-extension-v2.0.0.zip"
    sha256 "98ef34ca9734335151e73feea06c9d69cf208fce78dbd75daa1a00839344e046"
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
