% Part of the MetaUML Gallery of Patterns
% Copyright (C) 2005 Radu-George Radulescu
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

input metauml;

beginfig(1);
    Class.absClass("AbstractClass")()
                  ("+TemplateMethod()", "+PrimitiveOperation1()", 
                   "+PrimitiveOperation2()");
    Class.concClass("ConcreteClass")()
                  ("+PrimitiveOperation1()", "+PrimitiveOperation2()");

    Note.noteTemplateMethod("PrimitiveOperation1()", "...", "PrimitiveOperation2()");

    concClass.n = absClass.s - (0, 40);
    noteTemplateMethod.w = absClass.e + (40, 0);

    drawObjects(concClass, absClass, noteTemplateMethod);

    clink(inheritance)(concClass, absClass);
    link(dashedLink)(pathHorizontal(absClass.methodStack.pict[0].e, noteTemplateMethod.left));
endfig;

end
