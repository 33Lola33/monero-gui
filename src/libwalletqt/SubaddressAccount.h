// Copyright (c) 2014-2024, The MyNewCoin Project
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef SUBADDRESSACCOUNT_H
#define SUBADDRESSACCOUNT_H

#include <functional>

#include <wallet/api/wallet2_api.h>
#include <QObject>
#include <QReadWriteLock>
#include <QList>
#include <QDateTime>

class SubaddressAccount : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void getAll() const;
    Q_INVOKABLE bool getRow(int index, std::function<void (MyNewCoin::SubaddressAccountRow &)> callback) const;
    Q_INVOKABLE void addRow(const QString &label) const;
    Q_INVOKABLE void setLabel(quint32 accountIndex, const QString &label) const;
    Q_INVOKABLE void refresh() const;
    quint64 count() const;

signals:
    void refreshStarted() const;
    void refreshFinished() const;

public slots:

private:
    explicit SubaddressAccount(MyNewCoin::SubaddressAccount * subaddressAccountImpl, QObject *parent);
    friend class Wallet;
    mutable QReadWriteLock m_lock;
    MyNewCoin::SubaddressAccount * m_subaddressAccountImpl;
    mutable QList<MyNewCoin::SubaddressAccountRow*> m_rows;
};

#endif // SUBADDRESSACCOUNT_H
