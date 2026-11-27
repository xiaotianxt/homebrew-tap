class Bro < Formula
  desc "Local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "2.3.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.3.1/bro-v2.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "c94856faef8b17813d012316e4e996252cca5a26cd1f35bdfccbe9cb6cc216de"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.3.1/bro-v2.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "49df04136735c84b1d5caab4747dab9e0b83025dfeff5258b7b06bd87a28aded"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.3.1/bro-v2.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b030249506d9d51092a8511fec8097814c08f4621558152a7a2583a5b12b24b7"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.3.1/bro-v2.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c0ab16080995704fe01f375746f276c8e56a01573cb9659a746bf573a5006c2a"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "go" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v2.3.1/bro-extension-v2.3.1.zip"
    sha256 "f42bbc4402c4e2462f90a0f3b7955374e2d9b9e45ca1b331fabd71b23d360667"
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

  def caveats
    <<~EOS
      Finish setting up bro (background service, browser extension, MCP clients):
        bro setup
      Run it again after upgrading; it restarts the service on the new version.
    EOS
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
