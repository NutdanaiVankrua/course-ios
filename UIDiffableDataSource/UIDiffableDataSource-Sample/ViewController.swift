import UIKit

struct Item: Hashable {
    let id = UUID()
    let name: String
}

typealias Snapshot = NSDiffableDataSourceSnapshot<String, Item>

final class TableViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        return tableView
    }()
    private lazy var dataSource: UITableViewDiffableDataSource<String, Item> = {
        TableViewSampleDataSource(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "default")
            cell?.selectionStyle = .none
            cell?.textLabel?.text = item.name
            return cell
        }
    }()
    private var initialDone = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.dataSource = dataSource
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard !initialDone else { return }
        initialDone = true
        var snapshot = Snapshot()
        snapshot.appendSections(["test"])
        snapshot.appendItems([.init(name: "My first item"), .init(name: "World"), .init(name: "Coding in Swift")])
        dataSource.apply(snapshot)
    }

}

final class TableViewSampleDataSource: UITableViewDiffableDataSource<String, Item> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[section]
    }
}

final class CollectionViewController: UIViewController {

    private let collectionView: UICollectionView  = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            return flowLayout
        }())
        collectionView.backgroundColor = .red
        collectionView.alwaysBounceVertical = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        return collectionView
    }()
    private lazy var dataSource: UICollectionViewDiffableDataSource<String, Item> = {
        UICollectionViewDiffableDataSource<String, Item>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = item.name

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
            cell.backgroundColor = .green
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: cell.topAnchor),
                label.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                label.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
            ])
            return cell
        }
    }()
    private var initialDone = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.dataSource = dataSource
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard !initialDone else { return }
        initialDone = true
        var snapshot = Snapshot()
        snapshot.appendSections([""])
        snapshot.appendItems(
            [.init(name: "A"), .init(name: "World"), .init(name: "Coding"), .init(name: "A"), .init(name: "World"), .init(name: "Coding"), .init(name: "A"), .init(name: "World"), .init(name: "Coding"), .init(name: "A"), .init(name: "World"), .init(name: "Coding")]
        )
        dataSource.apply(snapshot)
    }

}
