//@ts-check

const bundleContext = require('@runtime/osgi').bundleContext;

/**
 * Returns the metadata on the passed in item name with the given namespace.
 * @param {string} itemName name of the item to search the metadata on
 * @param {string} namespace namespace of the metadata to return
 * @return {Metadata} the value and configuration or null if the metadata doesn't exist
 */
 const getMetadata = (itemName, namespace) => {
  //var FrameworkUtil = Java.type("org.osgi.framework.FrameworkUtil");
  //var _bundle = FrameworkUtil.getBundle(scriptExtension.class);
  //var bundle_context = _bundle.getBundleContext();
  //var MetadataRegistry_Ref = bundle_context.getServiceReference("org.openhab.core.items.MetadataRegistry");
  //var MetadataRegistry = bundle_context.getService(MetadataRegistry_Ref);
  var MetadataRegistry_Ref = bundleContext.getServiceReference("org.openhab.core.items.MetadataRegistry");
  var MetadataRegistry = bundleContext.getService(MetadataRegistry_Ref);
    
  var MetadataKey = Java.type("org.openhab.core.items.MetadataKey");
  return MetadataRegistry.get(new MetadataKey(namespace, itemName));
}

/**
 * Returns the value of the indicated namespace
 * @param {string} itemName name of the item to search the etadata on
 * @param {string} namespace namespace to get the value from
 * @return {string} The value of the given namespace on the given Item, or null if it doesn't exist
 */
const getMetadataValue = (itemName, namespace) =>{
  var md = getMetadata(itemName, namespace);
  return (md === null) ? null : md.value;
}

/**
 * Returns the configuration of the given key in the given namespace
 * @param {string} itemName name of the item to search for metadata on
 * @param {string} namespace namespace of the metadata
 * @param {string} key name of the value from config to return
 * @return {string} the value assocaited with the key, null otherwise
 */
const getMetadataKeyValue = (itemName, namespace, key) => {
  var md = getMetadata(itemName, namespace);
  if(md === null){
    return null;
  }
  return (md.configuration[key] === undefined) ? null : md.configuration[key];
}

/**
 * Returns the value of the name metadata, or itemName if name metadata doesn't exist on the item
 * @param {string} itemName name of the Item to pull the human friendly name metdata from
 */
const getName = (itemName) => {
  var name = getMetadataValue(itemName, "name");
  return (name === null) ? itemName : name;
}

/**
 * Filters the members of the passed in group and generates a comma separated list of
 * the item names (based on metadata if available).
 * @param {string} groupName name of the group to generate the list of names from
 * @param {function} filterFunc filtering function that takes one Item as an argument
 */
const getNames = (groupName, filterFunc) => {
  var Collectors = Java.type("java.util.stream.Collectors");
  return context.ir.getItem(groupName)
                   .members
                   .stream()
                   .filter(filterFunc)
                   .map(function(i) {
                     return context.getName(i.name);
                   })
                   .collect(Collectors.joining(", "));
}

module.exports = {
  getMetadata,
  getMetadataValue,
  getMetadataKeyValue,
  getName,
  getNames
}