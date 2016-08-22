using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Resources;
using System.Web;
using SCHUniversalAPI.Resource;

namespace SCHUniversalAPI
{
    public class ResourceFileConfig
    {
        public static string GetLocalisedString(string key)
        {
            return Resource.Resource.ResourceManager.GetString(key);
        }
    }
}