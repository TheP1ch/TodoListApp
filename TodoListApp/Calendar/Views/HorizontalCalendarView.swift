//
//  HorizontalCalendarView.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import UIKit

final class HorizontalCalendarView: UIView {

    weak var delegate: HorizontalCalendarDelegate?

    private var itemDates: [Date?] = []

    private var lastSelectedCellIdx: Int?

    private var collectionView: UICollectionView?

    private lazy var bottomViewBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorTheme.ColorPalette.gray.uiColor

        return view
    }()

    // MARK: initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        configureCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with dates: [Date?]) {
        itemDates = dates

        collectionView?.reloadData()

        if let lastSelectedCellIdx {
            selectItem(at: lastSelectedCellIdx)
        }
    }

    // MARK: configure Collection View
       /// Method create collectionView and set constraints
    private func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout {sectionIndex, _ in
            self.layout(for: sectionIndex)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            HorizontalCalendarViewCell.self,
            forCellWithReuseIdentifier: HorizontalCalendarViewCell.cellId
        )

        collectionView.backgroundColor = ColorTheme.Back.backPrimary.uiColor
        addSubview(collectionView)

        addSubview(bottomViewBorder)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            bottomViewBorder.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            bottomViewBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomViewBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomViewBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomViewBorder.heightAnchor.constraint(equalToConstant: 1)
        ])

        self.collectionView = collectionView
    }

    // MARK: configure Collection View Layout
    private func layout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )

        item.contentInsets = NSDirectionalEdgeInsets(
            top: 15,
            leading: 15,
            bottom: 15,
            trailing: 15
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .fractionalWidth(0.25)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return section
    }
}

// MARK: CollectionView DataSource methods
extension HorizontalCalendarView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemDates.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HorizontalCalendarViewCell.cellId,
            for: indexPath
        ) as? HorizontalCalendarViewCell else {
            fatalError()
        }

        cell.configureCell(date: itemDates[indexPath.item])

        return cell
    }
}

// MARK: CollectionView Delegates methods
extension HorizontalCalendarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.scrollToDate(at: indexPath.item)
    }
}

// MARK: integrate with verticalCalendar method
extension HorizontalCalendarView {
    func selectItem(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)

        collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)

        lastSelectedCellIdx = index
    }
}

#Preview{
    let view = HorizontalCalendarView()
    view.configure(with: [Date.now, Date.now, Date.now, Date.now, Date.now, Date.tommorow, nil])

    return view
}
