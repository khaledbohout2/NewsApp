NewsAPI
It's an iOS project which displaying a list of uptodate news using News API and allows the user to filter the news by category and country then display more details about the specific news article.\

The project is built using MVVM-C architecture where:
 - M represents Model to hold the data entities,\
 - VM represents ViewModel to handle the flow and work with the different services,\
 - V represents View to hold the UI,\
 - C represents Coordinator to handle the navigation and passing data between different modules,\
 and it's built using Clean Architecture to keep the SOLID principle applied and make the project scalable.\
 It's using combine framework to apply observer pattern.\
 It's built by applying clean architecture by using use cases, repositories to deal with the services.\
 app UI design built using UIKit fully programmatically to make All UI and screen control in one place, and Code may be searched and reused, and benifit from Easy code refactoring for experienced developers since the developer is in control of the UI elements.\

List of Modules\
1	News List handling the process of fetching the news list and retrieve the news data from the APIs, displaying that list to UI.\
2	News Details displaying the news details\

Technologies
Project is created using:\
    •	MVVM-C Architecture\
    •	Combine framework\
    •	Clean Architecture\
    •	iOS SDK 16.0\
    •	Swift version 5.8\
    •	XCode version 15\

Third-Party libraries\
Kingfisher which is used for fetching and caching images with lazy loading.\

Test Cases\
• use cases Test cases\

Environments:
1. DEBUG (For Development and Pointing to Dev Server)\
2. RELEASE (For Production and Pointing to Prod Server)\
3. QA (Distribute Build To QA and Pointing to QA Server)\

Handle Multiple Environments:\
used The best practice which is to use single target with multiple schemes and configuration and the reasons are:\

1.You need maintain only one plist file as compared to multiple targets\
2.While adding a new file you need to ensure to select all targets to keep your code synced in all configurations.\
3.Extra targets will be maintained in podfile\

What is next:\
1- add to favourites:\
create local data base using core data and add Entity to it save users favourites.\
2- Use single column for portrait mode. Supporting double columns in lanscape
mode:\
using collectionview instead of tableview and using UICollectionViewDelegateFlowLayout method\
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:\ UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {\
        let noOfCellsPerRow: CGFloat = traitCollection.horizontalSizeClass == .regular ? 2 : 1\
        let width = collectionView.frame.width / noOfCellsPerRow\
        return CGSize(width: width, height: (width * 0.36))\
    }\
5- integrate google crashlytics and google analitics.
4- offline first approach:
using repository pattern to have remote data source and local data source\
local data source is core data \
remote data source is network\
steps:
1- Observe Core Data remote change notifications on the queue where the changes were made.\
2- create A peristent history token used for fetching transactions from the store.\
3- Enable persistent store remote change notifications\
4- Enable persistent history tracking\
5- Execute the persistent history change since the last transaction.\
6- Update view context with objectIDs from history change request.\
7- refreshes UI by consuming store changes via persistent history tracking(viewContextMergeParentChanges - viewContextMergePolicy)\
8- Fetches the feed from the remote server, and imports it into Core Data.\

    


# NewsApp
