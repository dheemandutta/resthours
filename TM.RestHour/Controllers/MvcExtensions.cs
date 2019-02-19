using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.Routing;

namespace TM.RestHour.Controllers
{
	public static class MvcExtensions
	{
		public static RouteValueDictionary ToRouteValues(this NameValueCollection col, Object obj = null)
		{
			var values = obj != null ? new RouteValueDictionary(obj) : new RouteValueDictionary();

			if (col == null) return values;

			foreach (string key in col)
			{
				//values passed in object are already in collection
				if (!values.ContainsKey(key)) values[key] = col[key];
			}
			return values;
		}

		public static bool IsNullOrEmpty<T>(T[] array) where T : class
		{
			if (array == null || array.Length == 0)
				return true;
			else
				return array.All(item => item == null);
		}

	}

	
}