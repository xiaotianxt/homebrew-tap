class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.4.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.5/bro-v1.4.5-aarch64-apple-darwin.tar.gz"
      sha256 "0325059a68a2dfaf6fd48f61d0fa5089bacab5c5e9db71c2ca033991039f486c"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.5/bro-v1.4.5-x86_64-apple-darwin.tar.gz"
      sha256 "0f19010b49d5db1e305fc4f8cfa41d0da964caf5da475de808770a2c07fe719c"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.5/bro-v1.4.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7eae2b384eb9cf10077c9026ff17649238395dec598b005734010e6e52bbeb56"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.5/bro-v1.4.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "086ac34773978c8eeaac79bb481ee8bf346a41b06dbff1505b21b0b89d3630ed"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.4.5/bro-extension-v1.4.5.zip"
    sha256 "5d8fbfe01958570452fc52e4e2631a81eefc32ce2d063b5c52fb8bd1bf7871aa"
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
