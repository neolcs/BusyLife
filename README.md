# BusyLife
a calendar to show how busy you are

This app aims to help people track their events. We provide 2 view ports, the Calendar View and the Agenda View. Both views could be scrolled up and down infinitely. Sometimes people may get lost in the future or past when scrolling too far, at this time you could click to location button on the bottom-right corner to go back to today.

There are some scrollable classes in place, like UIScrollView, UITableView, UICollectionView, UIStackView, but none of them are designed to scroll infinitely. All of them need to set the contentSize one way or another beforehand, which is against nature of Agenda and Calendar View, we do not want to set a limit to our life range, that is why we introduce BLScrollView.

## BLScrollView
| <img src="https://raw.githubusercontent.com/neolcs/BusyLife/master/chart/basic.png" width="400"/> | <img src="https://raw.githubusercontent.com/neolcs/BusyLife/master/chart/scroll-create.png" width="400"/> | <img src="https://raw.githubusercontent.com/neolcs/BusyLife/master/chart/scroll-recycle.png" width="400"/> |
|:--:|:--:|:--:|
| *initialize* |*create new section* |*recycle obsolete section* |


The content of BLScrollView is consist of a group of sections, here of the class _BLSectionView_. As the content will go inifinitely, it is not possible to index the sections with IndexPath, so instead of making an absoute index space, we define relative index space with _BLSectionInfo_ protocol
```Objective-C
@protocol BLSectionInfo<NSObject>

@property (nonatomic, strong) NSArray* cellInfoArray;

- (id<BLSectionInfo>)previous;
- (id<BLSectionInfo>)next;

@end
```

We define specific class which conforms to _BLSectionInfo_ protocol for specific Section, like _BLCalendarSectionInfo_ for CalenderSection and _BLAgendaSectionInfo_ for AgendarSection, with which BLScrollView will populate the corresponding _BLSectionView_. _BLSectionView_ works as a container to help to manage the content views. As shown in the first chart, A BLSectionView could host an optional header and a group of cells. Initially, you need to set the bounds and topSectionInfo to a _BLScrollView_. During runtime, it will render the top section at first, and check if the sections have taken the whole height. If not, it will generate the next _BLSectionView_ by calling the _next_ method of the last SectionView's SectionInfo. The _BLScrollView_ will repeat this util the section views take all the height. 

When scrolling up, all the sections will translate to top, so there are new empty space created at the bottom. _BLScrollView_ will create new sections to take the height. If scrolling up to far, some top sections may go out of the bounds, as shown in the 3rd chart, _BLScrollView_ will recycle these sections.

The logic is similar when scrolling down.

#### How to scroll 

In _BLScrollView_ we interpret scrolling to that the content translate with the user's pan gestures. All the contentViews are located with its frames instead of constraints here.

```Objective-C
- (void)_translateView:(CGPoint)point{
    if ([self.sectionViewArray count] <= 0) {
        return;
    }
    
    NSMutableArray* toRemoveArray = [NSMutableArray array];
    for (BLSectionView* sectionView in self.sectionViewArray){
        sectionView.top = sectionView.top + point.y;    //translate content with gesture translation

        // check if some content need to be recycled or created
        ...
    }
}
```
We add a UIPanGestureRecognizer to BLScrollView, and make use of the 2 key attributes in the PanGesture, _translation_ and _velocity_. In the PanGuesture event, we caculate how far the figure sweep away from _translation_, and translate the content section views up and down respectfully. 
```Objective-C
- (void)_panMe:(UIPanGestureRecognizer *)pan{
    ...
    [pan setTranslation:CGPointZero inView:self];
}
```
One important thing here is to reset the translation to zero everytime the event is called, to prevent the translation accumulates.
If there is a significant _velocity_ when the PanGesture ends, the content should continure to move and slow down gradually, instead of stop immediately. We engage a timer source here to do the slow down job. In the timer source block, the _velocity_ will decrease slowly. When it is less than 1px/second, we will stop the timer and set the _velocity_ to zero. 

#### How to populate the content

Like UITableView, _BLScrollView_ defines _BLScrollViewDataSource_ and _BLScrollViewDelegate_ protocol. BLViewController conforms to these 2 protocols and set the dataSource and delegate.
```Objective-C
@class BLScrollView;
@protocol BLScrollViewDelegate<NSObject>

@optional
- (void)scrollViewDidStartScroll:(BLScrollView *)scrollView;
- (void)scrollViewDidStopScroll:(BLScrollView *)scrollView;
- (void)scrollView:(BLScrollView *)scrollView sectionWillBeRemoved:(id<BLSectionInfo>)sectionInfo;       //called when the section is out of the visible rect, hence is remove from BLScrollView

//the delegate method called when the top most section changed to another info
- (void)scrollView:(BLScrollView *)scrollView topSectionChanged:(id<BLSectionInfo>)sectionInfo;

@end
```

```Objective-C
@protocol BLScrollViewDataSource<NSObject>

//implement this method to return a CellView with the info from cellInfo
- (UIView *)scrollView:(BLScrollView *)scrollView cellForInfo:(id)cellInfo;
- (CGFloat)scrollView:(BLScrollView *)scrollView cellHeightForInfo:(id)cellInfo;

@optional
//return the header view for the cell info, optional to implement, if not implement, there would be no header
- (UIView *)scrollView:(BLScrollView *)scrollView headerForInfo:(id<BLSectionInfo>)sectionInfo;

@end
```

A _BLSectionInfo_ object contains an array of cellInfo, here in the dataSource delegate method, the value of the cellInfo is passed around, with which BLViewController could generate the cell views and define the cell's height. the header generation method is optional, we return nil to the CalendarView, and will return the BLAgendaHeader for the AgendaView.

The _BLScrollViewDelegate_ methods mostly explain itself already. We take use of the method to achieve the interaction between AgendaView and CalendarView.
* The CalendarView fold and expand event is triggered in the _scrollViewDidStartScroll_ method;
* The CalendarView current selection date update is triggered in _scrollView:(BLScrollView *)scrollView topSectionChanged:(id<BLSectionInfo>)sectionInfo_ method;
* The CalendarView section alignment is set in the _scrollViewDidStopScroll_ method;
* method _scrollView:(BLScrollView *)scrollView sectionWillBeRemoved:(id<BLSectionInfo>)sectionInfo_ is for future use;

## Events and TimeZones

The Calendar and Agenda will display user's event based on their local time, however event may involve with many people resident in different time zones. Even the same person, when he travels around the world, his local time may change from time to time. We need to find a way to map the event to different local time, we call it event settle logic.

The ESL(event settle logic) is done in _BLDataProvider_, which is a singleton class. It has an event array and a dateVM array, both array are time asc sorted. The event array contains all the events for user. _BLDataProvider_ loads events from events.json file and parses it to _BLEvent_ object array. the startDate of _BLEvent_ is of UTC time, and is independent with local time.
```Objective-C
@interface BLEvent : NSObject

@property (nonatomic, strong) NSDate* startDate;    //UTC time
@property (nonatomic, assign) NSTimeInterval range;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSArray* attends;
@property (nonatomic, strong) BLLocation* location;

@end
```

The _BLDateViewModel_ contains a specific date of local time and events that settle in the date. The dateVM array contains all the dateVM for recently visited date, and will preload the previous 31 days and next 31 days.

```Objective-C
typedef void (^DateVMUpdateHandler)(void);

@interface BLDateViewModel : NSObject

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, assign) BOOL highlight;
@property (nonatomic, strong) NSArray* events;
@property (nonatomic, copy) DateVMUpdateHandler updateHandler;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) int lineNumber;
@property (nonatomic, readonly) UIColor* backColor;
@property (nonatomic, readonly) UIColor* dayBackColor;
@property (nonatomic, readonly) UIColor* dayTextColor;
@property (nonatomic, readonly) NSString* headerTitle;
@property (nonatomic, readonly) UIColor* headerTitleColor;

- (instancetype)initWithDate:(NSDate *)date;

@end
```

<img src="https://raw.githubusercontent.com/neolcs/BusyLife/readme/chart/datevm-settle.png" width="800"/>

Initially, the dataVM array is empty. When calling _(BLDateViewModel *)dateVMForDate:(NSDate *)date_, DataProvider will populate the array with the target date as center, and preload a month before and a month after that date, then it will map the sorted dateVM array against the sorted event array, if any event settles in the date, add the event to the dateVM's events array.

<img src="https://raw.githubusercontent.com/neolcs/BusyLife/readme/chart/datevm-settle-preload.png" width="800"/>

When the _(BLDateViewModel *)dateVMForDate:(NSDate *)date_ called again, DataProvider will repeat to check if there are any date need to be preloaded. If so, preload these dates.

<img src="https://raw.githubusercontent.com/neolcs/BusyLife/readme/chart/datevm-resettle.png" width="800"/>

Sometimes, the target date is out of the range of dateVM array. In this scenario, the above preload logic could lead to inconsistency, so we will clear the dateVM array, and load the dateVM from scratch again. One important things here is, if we find the user's time zone get changed, the dateVM array will get cleared, and reload again.
```Objective-C
- (instancetype)init {
    self = [super init];
    if (self) {
        ...

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_timezoneChanged:)
                                                     name:NSSystemTimeZoneDidChangeNotification
                                                   object:nil];
    }
    return self;
}
- (void)_timezoneChanged:(NSNotification *)notif{
    [self.dateVMArray removeAllObjects];
}
```

## React and ViewModel

There are many controls in the CalendarView and AgendaView, and the inter-actions between them is complex, it is hard to display and highlight the date imperatively. We use react design to manage the states.

```Objective-C
@implementation BLDayGridView
- (void)_updateDayGrid{    
    __weak typeof(self) weakSelf = self;
    self.dateVM.updateHandler = ^{
        weakSelf.monthDay.numberOfLines = weakSelf.dateVM.lineNumber;
        weakSelf.monthDay.font = weakSelf.dateVM.lineNumber == 1 ? [UIFont systemFontOfSize:14.f] : [UIFont systemFontOfSize:12.f];
        weakSelf.monthDay.text = weakSelf.dateVM.title;
        weakSelf.backgroundColor = weakSelf.dateVM.backColor;
        
        weakSelf.monthDay.backgroundColor = weakSelf.dateVM.dayBackColor;
        weakSelf.monthDay.textColor = weakSelf.dateVM.dayTextColor;
        weakSelf.dot.hidden = !([weakSelf.dateVM.events count] > 0) || weakSelf.dateVM.highlight || weakSelf.dateVM.lineNumber > 1;
    };
    
    self.dateVM.updateHandler();
}

- (void)_tapMe:(UITapGestureRecognizer *)tap{
    NSNotification* notif = [NSNotification notificationWithName:BLDayGridViewHighlight object:self.dateVM];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
@end

@implementation BLDateViewModel
- (instancetype)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        // Initialize....
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_highlightChanged:) name:BLDayGridViewHighlight object:nil];
    }
    return self;
}
- (void)setHighlight:(BOOL)highlight {
    if (highlight == _highlight) return;
    
    _highlight = highlight;
    if (self.updateHandler) {
        self.updateHandler();
    }
}

- (void)_highlightChanged:(NSNotification *)notif{
    if ([self isEqual:notif.object]) {
        self.highlight = YES;
    }
    else{
        self.highlight = NO;
    }
}
@end
```

There is an updateHandler block in _BLDateViewModel_, the block is set in the corresponding _BLDayGridView_. In CalendarView, when user tap on different date cell, a notification is sent out, every dateVM will receive the notificate and update its highlight state, then updateHandler is called and the _BLDayGridView_ is updated.

It is also helpful to do the unit test with ViewModel, as we has abstract the logic code into ViewModel. The Views and Models would be more pure now.

## Weather

We introduce a class _BLWeatherView_, and wrap the Weather Request into itself to make a closure, we could put the _BLWeatherView_ whereever it need.
For the weather data request, it would make sense to cache the weather results locally. We take use of NSSecureCoding to cache the weather result. All the weather dict is managed by _BLDataProvider_. 
One thing to mention here is, a @synchronized lock is required to do the cache saving.

