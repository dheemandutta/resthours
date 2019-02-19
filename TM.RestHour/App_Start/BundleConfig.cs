using System.Web;
using System.Web.Optimization;

namespace TM.RestHour
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryui").Include(
                       "~/Scripts/jquery-ui-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/site.css",
                      "~/Content/bootstrap-multiselect.css",
                      "~/Content/TimePicker/jquery.timepicker.min.css",
                      "~/Content/jquery.typeahead.min.css"));

            bundles.Add(new ScriptBundle("~/bundles/datatables").Include(
                       "~/Scripts/DataTables/media/js/jquery.dataTables.min.js",
                       "~/Scripts/DataTables/media/js/dataTables.bootstrap.min.js",
                       "~/Scripts/DataTables/extensions/Select/dataTables.select.min.js"));


            bundles.Add(new ScriptBundle("~/bundles/multiselect").Include(
                        "~/Scripts/bootstrap-multiselect.js"));
            bundles.Add(new ScriptBundle("~/bundles/typeahead").Include(
                        "~/Scripts/jquery.typeahead.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/timepicker").Include(
                        "~/Scripts/TimePicker/jquery.timepicker.min.js"));

            bundles.Add(new StyleBundle("~/Content/themes/base/css").Include(
                        "~/Content/themes/base/all.css"));

            bundles.Add(new StyleBundle("~/Content/datatables").Include(
                        "~/Content/DataTables/css/jquery.dataTables.min.css"));
        }
    }
}
