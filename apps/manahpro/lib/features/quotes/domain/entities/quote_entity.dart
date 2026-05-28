import 'package:equatable/equatable.dart';

/// Pure domain entity representing a Quote.
///
/// Contains only business properties with no framework dependencies.
/// Extends [Equatable] for value-based equality comparison.
class QuoteEntity extends Equatable {
  const QuoteEntity({
    required this.localId,
    this.id,
    required this.text,
    required this.author,
    this.source,
    this.isActive = true,
    this.isSynced = false,
    this.syncAction,
    this.createdAt,
    this.updatedAt,
  });

  /// Local SQLite primary key (auto-increment).
  final int localId;

  /// Server-assigned ID. Null when created offline and not yet synced.
  final int? id;

  /// The quote text content.
  final String text;

  /// The author / figure name.
  final String author;

  /// Optional source (book, speech, interview, etc.).
  final String? source;

  /// Whether the quote is active.
  final bool isActive;

  /// Whether this entity has been synced with the server.
  final bool isSynced;

  /// Pending sync action: `'create'`, `'update'`, `'delete'`, or `null`.
  final String? syncAction;

  /// Server-side creation timestamp.
  final DateTime? createdAt;

  /// Server-side last-update timestamp.
  final DateTime? updatedAt;

  /// Creates a copy of this entity with the given fields replaced.
  QuoteEntity copyWith({
    int? localId,
    int? Function()? id,
    String? text,
    String? author,
    String? Function()? source,
    bool? isActive,
    bool? isSynced,
    String? Function()? syncAction,
    DateTime? Function()? createdAt,
    DateTime? Function()? updatedAt,
  }) {
    return QuoteEntity(
      localId: localId ?? this.localId,
      id: id != null ? id() : this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      source: source != null ? source() : this.source,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      syncAction: syncAction != null ? syncAction() : this.syncAction,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
      updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        localId,
        id,
        text,
        author,
        source,
        isActive,
        isSynced,
        syncAction,
        createdAt,
        updatedAt,
      ];
}
