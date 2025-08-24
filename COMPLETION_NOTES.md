## Implementation details
I added & changed several new files for the implementation as follow:

1. `NativeInterviewModuleImpl.swift` 
   - handles Swift implementation for `NativeInterviewModule`
   - handles `fetchPriceList(options: resolve: reject:)`
   - introduces 2 service classes:
      - `USDPriceListService` for calling `USDPriceUseCase`
      - `EuroPriceListService` for calling `AllPriceUseCase` 
      - Both conform to abstraction `Fetchable` which only handles `fetchPriceList`
      
   - init of both `USDPriceListService` & `EuroPriceListService` conforming to abstract `Fetchable` during `convenience init` if they're not passed in during instantiation
      - reason for this is for ease of testability & stubbing during testing

2. `USDPriceListService` & `EuroPriceListService`:
   - both have `dependency` & `provider` property
   - `dependency` is only accesible via constructor injection, if not passed in during init, it will default to `Dependency.shared`
      - such choice is to allow testability via stubbing as well

   - after setting `dependency`, `provider` of type `USDPriceUseCase` or `EuroPriceUseCase` depends on respective class will be instantiated from `dependency`
   - by conforming to `Fetchable`, they must include `fetchPriceList()` which invoke the (fake) API call in `USDPriceCasae`/ `AllPriceUseCase`

3. In `Model`, for `AllPrice.Price` & `USDPrice.Price`, I added a `toDictionary` method in the struct for ease of converting from struct to dictionary so it can be passed to Typescript in primitive datatype
   - I added extension of `Array` to handle conversion of `Tag` type to String as well

4. Testing for Swift is located in `CDC_InterviewTests.swift`

5. Testing for React Native located in `__tests__`:
   - REMAKRS: due to some babel/ jest configs, I'm unable to setup the project to run test, the tests were coded without actual running


## Performance Considerations:

1. To avoid unnecessary re-render of screens, in `PriceList.tsx` & `useInterviewHook.ts` I implemented `useMemo` & `useCallback`
2. `PrizeList.tsx`, to optimize for Flatlist, I used the following:
   - initialNumToRender={10}
   - maxToRenderPerBatch={5}
   - windowSize={11}
3. For all `fetchPriceList` being marked as `async`, this task is sent to background thread to perform


## Assumption made:
1. One module for screen
2. No navigation as of now required
3. Standard API called using HTTP (In reality, could be websocket or faster protocol used)


## Future improvements:
1. On `PriceList.tsx`, pull to refresh
   - If this feature implemented, need to implement Flyweight Pattern for during API calls to avoid excessiive call/ spamming
   - To achieve this, I'll need to keep a timestamp (If last refreshed time is less than 5 secs, I'll return response from cache), BUT this depends on agreement from other party for the reason crypto currency price flutuates rapidly, might affect accuracy
2. Network status detection, upon detect offline connection, will put up a small status bar on top to remind customer their app is offline
3. Navigation to details view, this can be done with 2 ways:
   - Both methods will invoke via NativeModule
   A. Preferred way - From the NativeModule, invoke the method, in the UIVIewController, setup a NSNotication listener, upon invoked, then push the DetailsView to the current view stack
   B. From the method in NativeModule, get the current navigation controller/ view, do a push of view on to it
4. Prefetching of APIs & cancellable APIs while scrolling using keypath instead of using pagination (Meta is doing such way) (But this required backend to coorperate as well)
   - Controlled response from NativeModule to ReactNative, current implementation doesnt limit the amount of data sent over JSI
5. Frequent data communication through JSI should be batched before immediate sending by implementing a "batch send native module"
