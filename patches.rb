module LaTeXConverterExt
  def convert node, transform = nil, opts = {}
    super node, transform
  end

  def handles? name
    true
  end
end

module ConverterFactoryExt
  def create backend, opts = {}
    converter = super
    if opts.key? :template_dirs
      require 'asciidoctor/converter/template' unless defined? ::Asciidoctor::Converter::TemplateConverter
      require 'asciidoctor/converter/composite' unless defined? ::Asciidoctor::Converter::CompositeConverter
      template_converter = ::Asciidoctor::Converter::TemplateConverter.new backend, opts[:template_dirs], opts
      cconverter = ::Asciidoctor::Converter::CompositeConverter.new backend, template_converter, converter
      cconverter.basebackend converter.basebackend
      cconverter.filetype converter.filetype
      cconverter.outfilesuffix converter.outfilesuffix
      cconverter
    else
      converter
    end
  end
end

class Asciidoctor::LaTeX::Converter
  prepend LaTeXConverterExt
end

class Asciidoctor::Converter::Factory
  prepend ConverterFactoryExt
end
