class EightBallVisitor
  module CallVisitors
    def visitCallOneArgFixnumNode(node)
      visitCallOneArgNode(node)
    end

    def visitFCallNoArgBlockNode(node)
      gather("this.#{node.name}(#{compile_function(nil, node.get_iter_node.get_var_node, node.get_iter_node.get_body_node)})")
    end

    def visitCallNoArgBlockNode(node)
      args = node.argsNode && visit(node.argsNode.getLast).to_comma_list
      gather("#{visit(node.receiverNode)}.#{mangle(node.get_name)}(#{ compile_function(nil, node.get_iter_node.get_var_node, node.get_iter_node.get_body_node)});")
    end

    def visitCallNoArgNode(node)
      "#{visit(node.receiver_node)}.#{node.get_name}()"
    end

    def visitCallOneArgNode(node)
      args = node.argsNode && compile_arglist(node.args_node)
      gather("#{visit(node.receiverNode)}.#{ mangle(node.getName)}#{args}".wrap_with("()"))
    end

    def visitFCallOneArgNode(node)
      gather("EightBall.#{node.name}#{compile_arglist(node.get_args_node)};")
    end

    def visitFCallNode(node)
      if node.class == Java::OrgJrubyAst::FCallNode
        gather("EightBall.#{node.name}#{compile_arglist(node.get_args_node)};")
      else
        meth = node.class.to_s.split(":").last
        send("visit#{meth}", node)
      end
    end

    def visitCallNode(node)
      if node.class == Java::OrgJrubyAst::CallNode
        args = node.argsNode && visit(node.argsNode.getLast).to_comma_list
        gather("#{visit(node.receiverNode)}.#{mangle(node.get_name)}#{args}".wrap_with("()"))
      else
        # for some reason, only CallNode gets a visitor.  I want to handle the separate cases separately.
        meth = node.class.to_s.split(":").last
        send("visit#{meth}", node)
      end
    end
  end
end
