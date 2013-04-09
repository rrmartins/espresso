class E
  include Rack::Utils

  class << self

    # allow to create new applications by `E.new`
    #
    # @example
    #   app = E.new do
    #     # some setup...
    #   end
    #   require './controllers'
    #   app.mount Something
    #   app.run
    #
    def new *args, &proc
      EBuilder.new *args, &proc
    end

    # allow controllers to define `initialize` method
    # that will run on clean state, before any Espresso stuff.
    # @note it wont accept any arguments
    def inherited ctrl
      def ctrl.new *args
        o = allocate
        o.send :initialize # `initialize` is a private method, using `send`
        o.initialize_controller *args
        o
      end
    end

    def include mdl
      super
      (@__e__included_actions ||= []).concat mdl.public_instance_methods(false)
    end

    def define_setup_method meth
      (class << self; self end).class_exec do
        define_method meth do |*args, &proc|
          add_setup(:a) { self.send meth, *args, &proc }
        end
      end
    end

  end
end

class EspressoApp < EBuilder
  def initialize(*)
    warn "\n--- WARN: EspressoApp is deprecated and will be removed soon ---
          Please use E.new instead\n"
    super
  end
end
