using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
	public static class RestHourExtensions
	{
		public static bool IsNullOrEmpty<T>(T[] array) where T : class
		{
			if (array == null || array.Length == 0)
				return true;
			else
				return array.All(item => item == null);
		}
	}
}
