# BusyLife
a calendar to show how busy you are

This app aims to help people track their events. We provide 2 view ports, the Calendar View and the Agenda View. Both views could be scrolled up and down infinitely. Sometimes people may get lost in the future or past when scrolling too far, at this time you could click to location button to go back to today.

There are some scrollable classes in place, like UIScrollView, UITableView, UICollectionView, UIStackView, but none of them are designed to scroll infinitely. All of them need to set the contentSize one way or another beforehand, which is against nature of Agenda and Calendar View, we do not want to set a limit to our life range, that is why we introduce BLScrollView.

## BLScrollView
| <img src="https://raw.githubusercontent.com/neolcs/BusyLife/master/chart/basic.png" width="400" title="Optional title"/> | <img src="https://raw.githubusercontent.com/neolcs/BusyLife/master/chart/scroll-create.png" width="400"/> | <img src="https://raw.githubusercontent.com/neolcs/BusyLife/master/chart/scroll-recycle.png" width="400"/> |
|:--:|:--:|:--:|
| *initialize* |*create new section* |*recycle out-of-use section* |


The content of BLScrollView is consist of a group of sections, here of the class _BLSectionView_. As the content will go inifinitely, it is not possible to index the sections with IndexPath, so instead of making an absoute index space, we define that every section can be inferred by their siblings by conforming to _BLSectionInfo_ protocol
```Objective-C
@protocol BLSectionInfo<NSObject>

@property (nonatomic, strong) NSArray* cellInfoArray;

- (id<BLSectionInfo>)previous;
- (id<BLSectionInfo>)next;

@end
```

When developping, you should define specific class, like _BLCalendarSectionInfo_, which conforms to _BLSectionInfo_ protocol. BLScrollView will populate the _BLSectionView_ with the secionInfo. _BLSectionView_ works as a container, its job is to help to manage the content views. As shown in the first chart, A BLSectionView could host an optional header and a group of cells. Initially, you need to set the bounds and topSectionInfo to a _BLScrollView_. During runtime, it will render the top section at first, and check if the sections have taken the whole height. If not, it will generate the next _BLSectionView_ by calling the _next_ method of the last SectionView's SectionInfo. The _BLScrollView_ will repeat this util the section views take all the height. 

When you scroll up, all the sections will translate to top, so there are empty space created in the bottom. _BLScrollView_ will repeat the cycle to create new sections to take the height. When you scroll up to far, some top sections may go out of the bounds, as shown in the 3rd chart, _BLScrollView_ will recycle the sections are out of bounds then.

The logic is similar when you scroll down.

#### How to scroll 

Basiclly the scroll is the content moves with the sweep of figures, in program we interpret it to the content translation with the user's pan gestures.
We add a UIPanGestureRecognizer to BLScrollView, and listen to its events. There are 2 key factor in the Pan Gesture, _translation_ and _velocity_. With _translation_, we move the content section views up and down. With _velocity_, we know when user's fingure away from the screen, the content should continure to move and slow donw gradually, instead of stop immediately. We take use of a timer source to achieve this. In the timer source block, the _velocity_ will decrease slowly. When it is less than 1px/second, we will stop the timer and set the _velocity_ to zero. 

We also want to set a threshhold to the initial velocity to 10px/s, if it is less than this, the screen will not slowly stop, but stop immediately.

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

## Time and Events

The Calendar and Agenda will display user's event based on their local time, however event may involve with many people resident in different time zones. Even the same person, when he travels around the world, his local time may change from time to time. We need to find a way to map the event to different local time, we call it event settle logic.

The ESL(event settle logic) is done in _BLDataProvider_, which is a singleton class. It has an event array and a dateVM array. The event array contains all the events for user. _BLDataProvider_ loads events from events.json file and parses it to _BLEvent_ object array. the startDate of _BLEvent_ is of UTC time, and has no relation with local time.
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

The _BLDateViewModel_ contains the date info and event array that settle in the date of local time. The dateVM array contains all the dateVM for recently visited date, and will preload the previous 31 days and next 31 days.



## ViewModel and UnitTest


## Weather

