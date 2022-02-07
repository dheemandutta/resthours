using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace TM.RestHour.Common
{
    public class ModelSelector
    {
        private readonly Dictionary<Type, Func<object>> modelLookup = new Dictionary<Type, Func<object>>();

        public void WhenRendering<T>(Func<object> getter)
        {
            modelLookup.Add(typeof(T), getter);
        }

        public object GetModel(Type modelType)
        {
            if (!modelLookup.ContainsKey(modelType))
            {
                throw new KeyNotFoundException(string.Format("A provider for the model type '{0}' was not provided", modelType.FullName));
            }

            return modelLookup[modelType]();
        }
    }
}