# minha-ferramenta.rb
class Environment < Formula
  desc "Descrição da minha ferramenta privada"
  homepage "tutotec.com.br"
  # O URL deve apontar para o tarball ou binário do seu software
  url "github.com"
  sha256 "insira_o_hash_sha256_aqui" # Gere o hash com `shasum -a 256 seu-arquivo.tar.gz`
  license "MIT"

  def install
    # system "make", "install"
  end

end