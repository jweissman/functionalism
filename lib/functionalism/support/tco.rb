require 'pry'
module TailCallOptimization
  RubyVM::InstructionSequence.compile_option = {
    :tailcall_optimization => true,
    :trace_instruction => false
  }

  def compile_with_tail(str_method)
    str_method = %{
      module #{self.to_s}
        #{str_method}
      end
    }
    RubyVM::InstructionSequence.new(str_method).eval
  end

  def xtail(method)
    m = self.method(method)
    self.send(:undef_method, method)
    compile_with_tail(m.source)
  end
end
