﻿using Antlr4.Runtime;
using sdmap.Functional;
using sdmap.Parser.G4;
using sdmap.Parser.Visitor;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace sdmap.Parser.Context
{
    public class SdmapManager
    {
        private readonly SdmapContext _context;

        public Result AddSourceCode(string sourceCode)
        {
            var inputStream = new AntlrInputStream(sourceCode);
            var lexer = new SdmapLexer(inputStream);
            var tokenStream = new CommonTokenStream(lexer);
            var parser = new SdmapParser(tokenStream);

            var visitor = SqlItemVisitor.Create(_context);
            return visitor.Visit(parser.root());
        }

        public Result<string> TryEmit(string key, object v)
        {
            SqlEmiter emiter;
            if (_context.Emiters.TryGetValue(key, out emiter))
            {
                return emiter.TryEmit(v, _context);
            }
            else
            {
                return Result.Fail<string>($"Key: '${key}' not found.");
            }
        }

        public string Emit(string key, object v)
        {
            return TryEmit(key, v).Value;
        }

        public Result EnsureCompiled()
        {
            foreach (var kv in _context.Emiters)
            {
                var ok = kv.Value.EnsureCompiled(_context);
                if (ok.IsFailure) return ok;
            }

            return Result.Ok();
        }
    }
}
