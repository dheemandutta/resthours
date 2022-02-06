using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Compilation;
using System.Web.Mvc;

namespace TM.RestHour.Common
{
    public class ModelSelectorEnabledRazorViewEngine : RazorViewEngine
    {
        protected override IView CreateView(ControllerContext controllerContext, string viewPath, string masterPath)
        {
            var result = base.CreateView(controllerContext, viewPath, masterPath);

            if (result == null)
                return null;

            return new CustomRazorView((RazorView)result);
        }

        protected override IView CreatePartialView(ControllerContext controllerContext, string partialPath)
        {
            var result = base.CreatePartialView(controllerContext, partialPath);

            if (result == null)
                return null;

            return new CustomRazorView((RazorView)result);
        }

        public class CustomRazorView : IView
        {
            private readonly RazorView view;

            public CustomRazorView(RazorView view)
            {
                this.view = view;
            }

            public void Render(ViewContext viewContext, TextWriter writer)
            {
                var modelSelector = viewContext.ViewData.Model as ModelSelector;
                if (modelSelector == null)
                {
                    // This is not a widget, so fall back to stock-standard MVC/Razor rendering
                    view.Render(viewContext, writer);
                    return;
                }

                // We need to work out what @model is on the view, so that we can pass the correct model to it. 
                // We can do this by using reflection over the compiled views, since Razor views implement a 
                // ViewPage<T>, where T is the @model value. 
                var compiledViewType = BuildManager.GetCompiledType(view.ViewPath);
                var baseType = compiledViewType.BaseType;
                if (baseType == null || !baseType.IsGenericType)
                {
                    throw new Exception(string.Format("When the view '{0}' was compiled, the resulting type was '{1}', with base type '{2}'. I expected a base type with a single generic argument; I don't know how to handle this type.", view.ViewPath, compiledViewType, baseType));
                }

                // This will be the value of @model
                var modelType = baseType.GetGenericArguments()[0];
                if (modelType == typeof(object))
                {
                    // When no @model is set, the result is a ViewPage<object>
                    throw new Exception(string.Format("The view '{0}' needs to include the @model directive to specify the model type. Did you forget to include an @model line?", view.ViewPath));
                }

                var model = modelSelector.GetModel(modelType);

                // Switch the current model from the ModelSelector to the value of @model
                viewContext.ViewData.Model = model;

                view.Render(viewContext, writer);
            }
        }
    }
}